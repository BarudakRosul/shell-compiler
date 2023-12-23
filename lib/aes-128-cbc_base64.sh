#!/bin/bash
#
# Author: fatimazq (Fatimah Azzahra)
# GitHub: https://github.com/fatimazq
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
]   �������� �BF=�j�g�z��"�gV�>�5I��k�Z$b~�����؊��$�䡉w|h��P�ރ}9V�WC3�ϋ�֮h�N�E�8�2T/D���F=��[7رm!٘����-f*�z;�p��Ǖ�/a��8�b�Ԉ��0^g&ВN$��F���l~?e�oJd�&�2�7����Yފ�6CJ
�&�i�C��Ot���꺼L��dF���D>6fr�6@J��m�k��WGy�{��+k�`R]�h��d�5G�D�4R�g��VM��Vt94"u_8��J��Ρw��*+�Lo�]�(�\�zG�!C�%m�am	p����S�r(�EOR�*�FQ�������yn~Z����Toˣq�,ﰧg�@���h��u7/ҴF�_8�7���ύ�]XĂ�r=�YM�����VٷHBV�(A9q]�Sk��gK�eS�M�^6K���c[��vlc��ݞ�8ut��~�A����	��Tt�u�.�֬�� ���/[�8��{tS��'[g���b�	6��8N4G�u��jV���	[a�dY�M��j�Cm��~�-_E}!�$g���P,AC��K,u��FЕ��ǃ���r$Twη�\*����R�^j���oBmTg���=�ٜ���5��>~������g�[�-�[j`��8
)��%�A�=�5}EMLs���1��d6�4� �+�4_��-OV8}�=���y��Z1kR��L'k��.��;:2�GV��k�g�=8yF��_�+4���n�[�6��Ȩ�!��pw�](|ًP�]=E,�g��%��(*T����#�_� ��Ɛ��t��"��?ˁ��zx#�r�kԊA%I�7�j�K����SIU�D�DM�=�ߧ���)�܂��\������� �H�O;y�}��8��Rΐ|�c� �pa�!^D�1��0Q�0 N��yX������xl5Kj��P.G9*��)X�06�F&C"�WI;F��l^2L�K���R�;w�V��x �TD�� �ދ�ȸʣֳWX_ /��
;rA/�#̃1AeR�bk#!��j����Y����'R�߂��IDv�S�X8�-����&����P�eAͨ\nzG��# :��ipU�Xڥ/@Fk�C6��x�G�\���X'�����թ���\��oD����$̢�:үޣ����;^�*V]C���
˳��lA�$ƿ#�A��;u�܄�l�z�q�t>��>�Ƶ�?��'� S9�2�Z��r~ &� ����.�ΰa.ߦ�+�ǟ���:�(D&r/7u>k������P*4W}��^�&�pE�x�����A�Y����iFCf�С���K�}F�sN��4�����6\|��\"����G�	/��P��C�6�R�2cOË�zԲ3��ih9fC�[��J�h��|,�E}�E��S�)AUA> �Kv��L�@�����.W88o5�t)��t[=J��˃�WK{!��qY�8dqKm�B����m{RF`�z��O�ƉtBΩ%Ắշ'R�#*���3�ʳ��G� �z�ԯ��}�7��{�Ѽ�0����OC94>���K�oc�GfO��|aE��b��{K�r�+q1�=f����l���hg���*�2�Jw��2"<^�����^�5�����X��Q�fyd�Q7Q9�m�q�n��6'�����7�
����w�7�Z-��o�h��m���V����ıw@:�f��*��B��u�n��s���k�i�D�B�!F��͢,�5�gx���B/7�0�<?�,�Ww�3�lù&�~^��{,���b�j���G:�򇻢Ȇ����|���͞gl��YJ
"W�~}��3�+�>�[J�^�G�Oyxt�k,��)�X�\�J�
K ��/6�vV�෹Vמu�BO ��P��c@�ju~ʥ�Z ��&$��2�p�)��K�i�����<K;V��Z�*�C�զRHzIr�.R���$����L+t��4������;��y~��PS$<�)ǒ���9�aմf�ď~�j�5k�q�����8�.p�.+���}�w���dtj�3��3ܾ����8[n�O�!�3:9z:r�4�v5�Ւ'���(�}V!^ecˎ$ӧ}c8�x�J�I�3�6}�M���V<h�a��&�׺�i��9{;B�b;���6��z6�I(Ą�h�S�t!�.��hk	W�Y��J@:i�b��Ϩ���S5�0������H��m���5�_��J�̑�Z�ǣ��Yo��r<�n�Ս���0R(A����N�Դ���6Zv�/{̌�fF��g��oZ)X<}����"ه,9�U�����r�p�ٞ^]}V��(!�"j�Z����P� j���h��B
� ���ֳ^	Ě�.�.�YS>ݹ���T��/K[�k�B��x���i�K����N%�3����2F�S�I*�	4���戥�elYiA`J�B�by+�l�O��u�j��a�[ZM�|y�����da�93t�>#��+ �������o��w�D�&���T�"Nt��G��V�]hb��@2�@`��t�^�}ɔT�ʁ�cy�2���|4���:��Na�a	@�F<�j
h��,��G�RY��ӆ�#Q$�X6�iq�pHS+ZV��=s�䅄/�!9�Ҍǹ���仾�C{!Tv�w��0͖��/��/SF�B���m&WE� u�v�C�L����?Hc�sI�5�)R�����]�ez�J
����P9�H�9�cLg�S��W���j�1���J�L?�c�
���N>1'����+yLGI�Kt[@#�K��a������E.�h�)�ySg��i�z؇'K���-S�q_ 
8!&����Z��SNx��PY���EbV:U���`e��3�G�ȋ�	 5)����`���~\B0�W��ۣ����j/)��T�n��?�����;��Ѿ�i�r����
�z�����������t��Yq/o�3b�:���?oI���Ğ	�ul�Ԑ��f�<����NTm����&.�l����f �;��g�h&Q��&*�ɕ�#=���?�K���+Ɔ I&8�mQ�)����;�'�����p}���RC��?��s����D�8L�}�Υ����tBn�;��H���IΈ.n�)�ޝS������?���y1��Xؒ�}6+��Q���<jP��~�QQ<o�>:����<���㼴����ԅ���x�k����(�@�ףU����X���⏪s����;�4��e����1G�7����Sl)�q���Λ�ɝ�:8ؓ�Q��&�
a�b��y9Qd�p���5��rFns�c�=��|�E^�-V0�Z���*nI�Д��GQ1|R��d6Q���O�("���o�_��Ag�^��>WCL�[�����@i�8A���o��H��[�[����l��OM��!K06������ ���ƧkrB�f�����?[�8z���v��6��pY�硻�����8��߈���8�d��,��u(���ԭ�Y=��(�����xj��1[����l�����M�!��w��F��h���G���z���WXy�Xޑ��ѷ�@-�n6��r���|���t�4}�F1Nw��͏�Q�.l՛�`]�ԍI%���ҧU�٬�KMԙ(�_RP`9��6�Q����0���4�$5��7���[����l	{�;m��̊U�=F�,��2���K�QL�&Cs��@�R���6]a����ՉMi��'��~�P>��1.2}d�����f	�t@�*�u���k���^�QɼZ��L��`̱Ѥ����I^��a��JU�Z䅀�x]�@F�=o���+L���ћ�Ø���-�H n'?�}=Bi1�A��#TvGj#.&�����k�`�#�U�_��sb#��r9�m33@�T�<Eq�Pw�J�����lM�ш���`��=�Q�]͕���|MyR?L�?`�Zf�_]��`���0�,g	�!	���|^spӏJx�i���B�BdAT>V�@:6��Uk$��N�홉_w��5D��ɗL�����
y͋��JJ\I�������K��s�*�c��\e� ��	�ג���j��=�u�H�r=�[��1�{�c7(�~]�_�Iح8!l6OiU���$��ǳc%��0�ΝW��N0�ygY�K%,ꊠ����L�>�t��YHv���ċ�S)D�>��K��(�e�o��9k�i ���ZFe§��Ԑ,�>R��h�T��F��m���Rl�>z�i6�W+"0���N.��v�l4�HeD#4�(�Rh�˻G�h�O7�'�2�������p���Aݚ���+��T�M�E'cI\n]`����[�g.��hk��p��4V��%�8'�ls�Z{8�n˨b�͚vG~�"�;��װ���I?o"B�G�a��}�=ބO8eW@�ãd�م	�Li��):�On@o_ә��W ��mf�w�o�;LƲe�p��5�у�ae��%�k<zK�p�Fz�hr�<��x��^�6@!
��pu,Bi��Tk�����p����o\��e$|K*`�c��⭾~�S��
Й����K2F���7K ���!�R�	�ٹ'!���R��1f*+���֐�4���ϲ�u75����d��g�;��93n�i�ί���D��i�}�b8W��kKcA4�\c��@ ��I��`L��`��/�e�]]L�~7��&v�l�pT��-���	4�$m�8�n���/����$.����� n;<Y�¹`S,2][)���A��-�U0UR`�f�d�0֛������B ��S%$����2n\i�(0G�^8�ț�5u"�]\@���]/&3f�~�Lo<V$�3�OM:T�N���I�L*�l%2=�$�*�P�C�u2[!�_ShkYgv����F-�|�3%KL��r��b��r'&�;���Y�h���!�
@Z���4��L�Q�b��初��Ų��3*ޘ�j��r����tR�شW�W\��qKU�� ���9Z� ���`�E�_\D:�p����C���1�.�+a�wF�a��&I1VԓW��i�C)�J�A��Pn�זO�ܟ��@�_^>,��� ����X+��˰X���~��އ���
���� |�	Hk+���{����nY����2T��xF�އ��`�O��<��6�!�`U�v�A<`i������N�@��7��Z�D�qO`��۳��b|=l T����=#�����VO 㴺�,nJs_���&,�s9,�+���˘"��g��NMq�ܓ�M��U/[ۼU?�.s��5�&|&E1.�%�͟�|I"<�y���t�e�}�z�k���s^}�w<��L��fw?;q-�)��d���|���\�`�1��W�$����+���e�~�(��#F�o�¢�Y�.@�D �$���n��Q���4���7jNN��%N�"��W#���%�