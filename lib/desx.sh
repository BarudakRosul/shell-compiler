#!/bin/bash
#
# Author: Andi-Rahek (Andi Rahek)
# GitHub: https://github.com/Andi-Rahek
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5JΨ��L�kȚ�K�=��P,^yo�7�Z$�B��6dp���IԋX%@s�����NO�cH������Tҫ� ��o��>v���� b�T˛�rmC�Ik�AjVʴ�;p۹��<��69��<(H%,��Ȧ�����DkK!�=�9�ӯƾ��L�a�'o?��I�������B��I�bR�%���L=a�v�����MV��)����HhөMb�T������|l���{�	��|�d$�K���]}�u?�ye���#A��`�G�ET������V��ʇg')k��2f� /N8���ӆ16�ӕ$0ٓRԬӋ�n�t�ϑͩO�2:�A4X�f�fj��G+���r}��Mdf�c'�OS�=��� �+�Y�,� �r�4+Y4`�&Uҭ���.��������,p��+3Ht�Xɒ��o�HM8�]�d�$���Q���7�?�7@��r�R���'(�.�b�������ʝ���;H¶�t��#n`~G�ip�#��:MU�)�e���= �Wz-��	�>v�B
f6��݋�(U �*����j�x��=���Hm��}�}"��V.�ЭsT��^֜Ϛ}����U������҅�(]#�\����p�������ϊ�X��9�ڪ�����Fy�0��އG�"�߃zGZ�=���u��[Ef�,�|=d;֓2�n�����,�ڇR�c�{�m�����u	�e{7g��V����w�LT����x���ߥ�u����K�>���z}>Kqw��� hQ���5���o9U]��嵗}�$�Jy�T�0ҳOh%N"T{1r$N�Ң�(�WW�D�әo�]�g�:�D�Kt�)��+�Ki�e����c��d�i| �9|E$cѼ&���d@=��k�:���bY�y��:dX���"@�C�B(�ݵ�y ���ꩼМ[�֣�r�3����ȰaA�����q��_Q����ٺ��M�HS
h?����ί�~e���a��2�zD#��Y���%�-�M}�w'zmq��N��k���x`��#�/uw���Fו��:X�r!q�^�,�.���P����#g�r5�l�!��d�,��J����ox��G����l)�ꌹ���\��2��/��Ꞌ�qj~�$� 4qB�#��n���d
m���4�*�5�nOLP��U�?$�	��>4�B�x�i�?ڊ�P������>C��1`A^��C'��?Iͱ�8[���O`��g��e�.����;�����yLC��-�Su���=�G�q�ӆr�����sEXbɔ��!Z6�y�ĳ�wM���a����7;Rk�c�?�"�	B�D�ku������c tc�x�z��X$:Y*����j���y �^ҥ�|�L���������Fp!��~��%�T8�)o�I!����V�$:^�Զ#+㗶�O�'kpy���_3_�0�jG��|7ËSwQY�ڡ�xi.��L�!�������1�!�7�>w:���?��S�m�s���a���Â4�YjJ���nq܍�_��������?��/��ͻ*�����8]n#j�j���f�X&O|��jKހ��\};�bmig�d����g��1�$-��,I�'��:��1��a��.��!=$(.ѭ���$�[cmj�n{.�� "S�@�,8�4�p�3������O]r��l��D�`1X�����^ ����H���d����XZ@l4�[+Ճ�r
�"$��d����P�Ʒ��9w�-�<;+�A�Ѓ��?��	�������v���'��0v��Loda��@Q��lCJ�¡�p�ql�����D�*��PU %oB(#��r�Gu̩�F�B�1�����X���N�q������~����y��!%��Ko�q��`,s�Tԧ�.��n|Y�)����E|B��Q�8�4"��Y+�̧�����""�f !� �Cޥ�g�H��O���&l��P�ρ�:D0�]\h���n�����S)l���������9(��!G�=��`M���g	0��Y��V\H�p�O���(��[���e�1��˄���:/�9�o��L�-��yA������A"���rO㋅	X'�ˍ�;�s����s���`g�׷����l$�}vg���OqD�9�2�w����\�B�i� L���2��"y(�+"?��'�će�#�cW\%���4{����w�ֺI�ޑS�y��Oy��xU]��)/�p'�~�����fa�}yi�\Dxb�1�89��i�O3�p��KAr<��B/p�g� U3��ICb�ɝ����\����|���D9�a :���#!u�o&Q��_��|K�v�³�S����Z�w�����O��;ϴ��7�2��������qݯ�@$�7ɝ��$��@m0�k����x��G���wL��V�\f��5���7����AՀD�M����Џ+�R߬b��Z�Ő�U�o`�D"5�FA��k��r5�n����  ��6�ѹ�o-��o�w���Ev�5i/��E:��9hih~��L��;�5��r�2�y���:����[Z`5��I����mٕ��`��+l7������i��ݟ$�����P��	n6�'h���%h^-��*�Y���g(�Ŏ9j��}����`MT�r�>2=�J��^��y˯h�����Ie��Ũ{���?1{����V46�h�ΰ�qK5��Z��LWN��0`)����TE�B�P�i�j%���(�1
l�M���gi��[}����{�q�v�_{��0�/q��ih�	��d�bR��=�;a�S�l@Js8�B���C,�@q�Duw����X��,G+vB1��k�^�㒢�2[g1nE�AA�uȆ���6�����1���V��	�%�J���)��S�ν��]Җd=���Ň�2�H�R����t��[��ꛜd�Al���wO��UZ1���Ny?�,Vsv�6�r��	Ch�"~&�w���o���ަ��dF��q�'ʺI�]t��{s9����Y�md�lt��*��r����8
i��u�%�
��RW���.p�n%�"
��������Yn���p7� �cs	#��[!X�1��>��5�1�m�K�_
���Z]�����'�$bg���N�yd���bd��l(c{6��:�3��I\���)Ad:�s=��pW���
)�I��wS����)Cd����b�._,�0ڐ�>h[�}s��'�;6��F��-,>�`�{H�&�*�}-W�.ԭ>��Gd��c�;����_'���+�{ߟ$t?��A�=�fM��!'Av5vj<�*2s˿�:��)@h��Y]/ "�d3���@<�"�+Qk,:�U�##�|�D,�tK�v�3���{E��f
R�������Q^��g��N��u�5-C+�i��B��FY�Y�KVr=2Y�nX�V��[��|(k4͇Ôڴ��P���Q���'Ϊ%Qy��9����s�= ��w3F����y��o�#�����O�8��j0!`t��м�O") �w��j�#��Ұ1��r��Ⱥ5C��Q5�2@������t[`E��Mnb���,���:V�9��x(νhǇY���î��,�wo�G~Pqi�9����݈�֟�+v����~*O/;5�������j�B��8�c{V����)��S�� \*�U2��}�#�^D��wm��� ��.��z� 5�e �ͅ,!��X�`���� ]��F�Y:��Y9����ߍa�v�s��F�Z�T�j]LW��g#m��hy�7[��l�_@�-�\�(�NB���A��hD�jMu�x ���1T4Eͪ���y�����h��H�默��wWK�0�#���ޡ۠@� K{�k׌��fpn��t��. m|Uo�`�wiA��������N�'N|�\�>:c�)V�}��D��WL��s�����sidC�T�)���T�X��lX1����t:���:pc_�p��[%g���^��7���ύ�Y�֗�`�H%~{���^U�:�Ө�/��󇁔��|Ҏp��̷���.��(O����]0'��Q,z�?���Y,ލm�3�/��E��n��n'u���n�8dEM���A�%4N%�$[͜z�>��guܸ�qoaf(���+�4�kP�ˇG�;jƱH�b�k��{X�P��[!'�|1�kk"*�M�ʋ#�S�[̢v$���7CޢY����`�qS�k�:P5��h�2u},��do7A��X+՚�Y0��G�7f=� v#�:0��H�j\��KG�+͇�^�d�r��7O�m&�g��_�zB3�����e.z�G� ur��wN���a��$J�w����B����:�����/D��'����}[��ϒ\E��c�DלC!�		�g�boY�g����-/�B��!�V���:8��_[+ZZf�J,���/
�l3[I���jx"#�S����U\pa�������w��)]��2�g��R?+����4&94,�ovR�^}\���#�CQ�1�.��(fj���	��/Y���G�J��%,6h�]�$lX�X���%���ZO:]F�q+�?R��D��y"����o�\�9�t%�����	��Xh���V��hs��d{�ռqm�ˀ���N�ڶҁJ��q��ǭ��@��DԺ0tFO�b�s5{�zmL�6��Ia�i�P/�1\z����\ضn���Oֳ2�����"Mc���3��4�	�R�ul ��;
qX�������%0�Av��B�r�Sv�3��\�@��4�y~f ^]7g��]���:�]C��
��6 =W�r�^�f՗A�Tݤy6G��w��ֶVq�l�e�)ك����jv��BH����v����4\R�P�2����56�rT�Sz�E�k8��ʥpݲ��"V5&[�@m!�����|�31n���*G*ۨ���Pl�O��Ӯ@��ŁI��j�|CwQf=(>�tH�Ŕf�G�#F��T�+�ɢ�bD!�x�O]�ײ��l	*O'�\��8Q�ڒٷ���s�(Ñi+_���js�K���F���	��4>&��NF�5�Xx��M��
���m�VZާ�6(��+��/�����\[H�̍�R����,M/�Qe.��}p�������CP�Z�~xH�����k{|ٌG�V'�;�8@�����3�e�c�,�	 �C�Mrj�f6��I~U���4��C��+
)a�S��Uts�k�Z`�I�@d����5(�C[��s\ȋ�9����cCڭmz�f��m�Nžnb
2�j�֋ثD
P�'L�-��K��Ee��a@���s��a$����NGD0�̧�ql%fj2=ʏr(��,�����h}5