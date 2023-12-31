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
m���4�*�5�nOLP��U�?$�	��>4�B�x�i�?ڊ�P������>C��1`A^��C'��?Iͱ�8[���O`��g��e�.����;�����yLC��-�Su���=�G�q�ӆr�����sEXbɔ��!ZH�~Tē�wM���a����7;Rk�c�?�"�	B�D�ku������c tc�x�z��X$:Y*����j���y �^ҥ�|�L���������Fp!��~��%�T8�)o�I!����V�$:^�Զ#+㗶�O�'kpy���_3_�0�jG��|7ËSwQY�ڡ�xi.��L�!�������1�!�'8��})*�aKu8f��o�6�@p����U�e��Lc�Q��/T})�u%�N8D��ϚX�yn\��"�(�'�n5:L���]6	J��!f6�4PҤ��^�l9	d���1���{v�>#��yo��R���i51�;4��)�����0H��­�ӣ�j57BV�9
��Oi�}��cٽi�Տo��`uC�U��%Q��4�����΋�)B�.!���A���
-�o �Ru��KX�'���Q<��Ї[
q&�hY�Z{�)$�$���3ĝ�]���"���;�ki#h��2�U�MO��%�yf��sL�mȣ�.È
� ����;��r��C�3����j�E�� }GV'C&PT��I�p5��9,	���ңlGh8wɶ�����oЏ��,[M�\��6�Su��$�ť}�ɶ�y���,�Ԡ�]�O�ǚz�����R͑�d.@$զ���l|y���>ićJC�WG�=�&B`Yi�#A�V���?�H��>���w�@fJ���¹p�u�#�<�8нp�!�@�������s�����}��\��do
	�8�p��h�`�Y,�y�`����xp�Tvv ��\�-6LY���#k)�~���s���;w^����� ��E Z�����*����t�沚���+���w�+�o.)�A������Q�uK���91�%��YwJ��)�.���O�GK.Yk(�dd:�=/����۠-����a/��T�Y��$+��k���9��܈�潅����-�p(
a7�`���*C��PM6#	d_���{^��Q�*��y���*�s6��7v8k��e]=>B���L*�L*m�8ϑ�=:gwc��j����뜦� ��z̃8Ch��y ����x�L��i*�Ks�����dv��qY��Q��&f���ysFco��{�=��:��:�i^e~7�B��0���M;�Px�<��Ͽ��.��y<j�����B�����9.�q�H/�CԱ~�:�P�
Jt�䤱������Ǧ�������B��vt��:w� &2.�g���uL蛤DbD�P*dZ�0Ց��b#'̍��l ���L�L2I���S�����I�i�����D��)}�'�JuI��Q�T��q�>�B崮��X����0%D��T���T�W-���5C��pi�(�;	�`��8׸�72j�G`Z�\x���F\Wa����9-K��`g��U������"�M�E�KW�m�=de�����z�l��1DL3ct}=��ѓƕ������9�5�3�"xTq��@%~*�o`J����$�֯�gg/��632\t|��Jy��Bfz�	Rsa~�X���"�`]�j��jH�6hh��H�wI d��n�oc�p���$��[�"�eGp"�T{ �tih"4O@�]B~X�A�)�ٵDկ�8�-&/Y�ϵ�Sǉ!0���VK���G���H3)p���8���]\�YGa�������R������Z��8���̙xf�$��B:��?���a��J4��W�?�qv��b�0K%������%e��M^N��E��Xi
 =7�����*�q����?��$Mj���iRY|�^9����wp^Qk�4R���2�Ub�C��ϝ(ѯ�Ɲ�+�~�_~8|��^b_�>���� ��{�pĪ����;,�W.���y$j�ݿ�s�X]���9ː.q7L���?A�0� G O�7�׌�}��e�[�ؓ�N��p�>
�8M��|�"D^D)s!wn�T�I���4������t|�w	�PD�J�L'7"�i��F������M���L� �DCi>q.c[,E���Ii�� �� �D[@q�ʂ�9�n/nKl9�=/�� 9���)@h@}�Ҿ� �p�Y��e؞ ��n��ˠ����[w��!��TNWH��	b�F�hH�@-�(?!�g&��D����=������e|C�����"/@fn�y�T�k�]	�a�.�X�ړL�Ue���R�[>��z�"^lȿ4�Թ�6��)F��Q����7�y�Y��<<�������k斬I�}�m ���]�޾�w&�۸Ł*R�+�/�uz��>�C�f�d7�Ӑ ����m�s^�暿nF�Z}�4x�~��������!������_�^�'�K^�Ai�Ȋ�e4&���v+E�۵\�HW��jwޭ����y�vI'gNk�ʠE'�����*� ���c�$���
���������$z�䃶�_1�{�#t��J��"�pq^v��`�a��YKD�#�'�n*Ğ�8�X���j���.��3OO�1O�,���u|���\Z��RD�R�}�s�.9��%xPb��"�&._��
`F�4[E%�W⊝a,�rDRź�|��/��5RmJ��b�С��Ye�x���@Mѕ�XP	����y��J���������L?�����HYwN���Dt!�;��W!�g4cETz8�c2n�A҈ޚ�Z91�@�b��tuȠvI�����+��UY�5{��0(8��{r�h/���W�kտ?H�y�wot���5�u�R�����8s�	�d^��k㨻]�.�Jy���S���!�❜$(�4ry�<YU�+���G;l񷼟[>��D_���&R��t��R�(hj/Ei��^�����H���K�lƚӈbQ�.�X�U�����gd�5I�6n��t�>kU"�/��r���d4�/��]�؃�m��n�2c�%�yܯ}i�P�܊"e�!O�t��u����ܾ�Cف�dM@��?�m穠�XMcw�R�Lw�s�Ff5������!��$�Y�|�S��JT��~��!Cί�Y����(&h����[ȯ�#��q�u�@ڳ�g��X�9}F���X�vKu'(d����7�<^[v_ϡ�I�D0x�q��j�!2��}
r�\�1�4�-������קM�$oս�K:yĀ;�X-��V��x1��߶vܳ�&������!v���k!\X�%Z�a&opA�� t����'L:��S}{��T��6EHR�{�-SI��7�^�Bx�3���˾^�Rv����1��P�e����v�\�HN������
��:qǻJ�LR��H.����h-�Y�������%�Sw-k���c=�X`�7� �t
�qy���G���#����xC�9���m���R20S�F���������U]y��aa��A\�|��x�c�ZO�w�3�f����O4�,f���>������h�o��m�hyK��hWR�.t6�'�W�3�b��3W)]�psqC�j���h��� � W<a���*�����~�{r�����ź� ��b֊�WK�����J]z�t躖7�Q����y��y��F>�{��7Gi)M®�дKC{�g3�2'0e�˕��t���:bv8卾7�^���=���@��#� ���G�,�n�OϹO0&�m�?��S��3�!�M��_ȏ���<��>Lꔌ��L��L��/h������uJT�N;9S
k��"��%k�%�Gx{�a%��p=6o��Z�F���?4Ct���p����� ����-ϯ���UX���t��ӑ�aJ�ȹn[��X�Y�JNU��>�T��2��(��;%��ʪ��fȌ����gO`v�@>���K]*�6����1��`.�E�?V䔱�� ��͓�bHM�d����./HC��M�o���Ih~�~�/��N�~n����a���H�67�}��c�>;@�,uzI]���B4�����ۚUۉ�T�#'��/�U#��ʉ$By9�$�R+.$��[Y$߬�?Tj�d��X����".�j(�!�l	a�SC�F�+���iu��_���Zi��7�,����q�������O��4h����