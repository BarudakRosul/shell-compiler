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
˳��lA�$ƿ#�A��;u�܄�l�z�q�t>��>�Ƶ�?��'� S9�2�Z��r~ &� ����.�ΰa.ߦ�+�ǟ���:�(D&r/7u>k������P*4W}��^�&�pE�x�����A�Y����iFCf�С���K�}F�sN��jQD�B+��C�
�@>R$���|�{����jV@f�1��<<�Hhs:G�V*sr����[?a0�S����`�E�(�'Ʈ�aZ	��yb���^&@U���<�V�F��7����2lF��s?�G" ޑ��rh�/Q	�s��5A坪����0bW��؃O���ȵ���s{���e�G������ͫm?�h�{�'��<�0�H3ݮ�w(�ġ������
!�a.�h���1���[Gb{�ô
�f���M�"^5�jz'&D�y�'�k>��icpe�ڒd}>��~�Ƿ��	��<khc�h��6�Z��Lx��.�c�:�|��|ƽ������ u�\=��v���@�`6�g�0�@KO1��g�Jjqu�8_N��f�d&��{���'hXh�l�!kS���6E'��-Q���]��aB�mI\�߀������d������訑!r9�m�dzo�u5cDY&�){I(�M_�l��=�vO�1Lאq���������'��A��s`����p�pL���Zɲ� ���ʩ�	\�����޵�zg��+��~_r�0A�'�fM��G��+�֜�/�<��Up�6��N��1qg���N*�b�z��4�TU�����S!���"aT1t�s���"1-�=SNde�Ld,N8���_S�ۜ~�){)�Iw��x�U����T��Gש��L��2����CǾM�C��`��e�Jl�T���O�ta9♯(%5A�_����ak��Bi��( �H�'Yf��$��3�㴪"��Z�f��i���Fd#B������z׀�en����|�=�U��m9�i¨VG��H6�)��;�d=��7�pilE��q|��N��Q��R�+5�\3�#I����KQP�zV `^�I��޿�1c<rÂ�E�G�]4��mp�h�|U:>��紃 oNa�sN�5X�4�M��v�����m-(��;�hx"�uO�ԴP]�m�z�}hj�.��ǝ'C-墾�C�՘���7�>-~�C���E�	ᛉ���e>�j%�����S��L�[��P�G5!<O�AL��X�;�ڜV���L0��	x�B�Uw�\��x<N����u�Ym��L]�Ħ�5�er�L_eͿ��w얡�<G� �Y}�y�A�
�s{�i��5,�h�������G�՗O�����q̢\fHk���nYJ�b�Q^M7ɻ��y#�8��	/3�� Ѿ���k'�/���Oi�b�j�'C�:5��s6�m6�߭<ljx����@��IDk�
K)�� j"�]|M��A�'+�Ԭ<�mm���x^'�=��w�"h��`-*�[�mv_݋�&+LM�!��b����jg�EA7�se"��q�T�=�j��omV/ʊ���d��O�Vc�6dg�ϸ�C��\���Zh����� O�-Ia��8���c8w/B����Ʉ	�KI ���'����49�őY�%��v8����Ị/JPS���=�����A��K��^�7uH�ŨD=�~���Q�3�f�z �����W_��j��G�М�	�^�9��2�+�4n+]鵨P���y�Q11K��`R�[�������4&�C3��1MIg^:�����%
Q�Jk�郞�>Y��b^I�rQ@�FJ7��2�7^ϯ�B��#����xJ�ɧ}�����ҰV3`�l������E�ID�꟏h�k\�z龴(\D6
Vdѵ{�ݐ�A��h$��x�_���\�^�S��ۋha��9�������_�&����m�e6�KLM�;6g���fe���lij
�\���y�TRr�G��$�S�4��D`WfDLЎ�a��Qʫ�t9c�����Mx����J��ޮ/j�T��h�MZ�, e�*;��$_���sb.��W�xK<����O���
��'Ml����/mG#/����9D�y/U���wX�^���R��=v�������ݱO7�(l��M�����u��H�>��'�=y��M��f�1�!+��}�%�#]�I|���ģQ�gIy&	`*�"�����k<���$e�|�^-x��/J���:�l��W��ʬT�T�4�N��׽6�h�I�̢E��y�rR; )Sc�f�v�s�����EO�ƶ�v�"
)^O�%Q`Z?�*�Jo&�XCR"��vDRnWU�p9�䦔R��Ajq�R�Rʡ���S:Gp�3��e���~�X�W��N��T���:�F��a�wFU��|(��J6@p6���U�]v����,�w`���zoѽR�G������N!;]�)��2M�N�2v|sUMnQ �|V��v#u�,�t�ܿ���W����^�Z����O7Q#ݏ�Y9�/�(���Iy�=���}�%/Z�@�6��(��8g� �	��W͜9���:Ews���G}d���;!��ow�I���'�����U2]:5�N�m/�7����H&�b�"�/xq=�lI�Ӯ�#R<m� ��ϭ��=x�j��nyJ�#m�&�D��euV�uQ<iԙ�~��> G��o�y�T�O�dy��N-�o�:���I� >��c\�	�b�S��qr��tƄE�u���q}nG
K�{�5�d�w����ͨ��b��o����8�)&&II��%"�n�>�h��tmVY��_�����i�B�Y�@3ܛK�7�_���6�B���h���L�&�ʸ�����q}��^�����]{��)p�ɟB���E, !�OX�k�"�E��飲j����h���ހP�T7��D��Hd�����+��0do@��^���AJ�/.�9CT����BM�ρY�P������Bs�Y�n�6�hc�3*����)~�OG�J�'�
ˇ���������!�.�G�t$/�{����q�G�os
Ũ��E��%��H*�X�?��[�|о���� �z��N��8K�)�3&+�p�/���<�g`J�7�=�Ov&�׎0���;�F��orli�?�[���)?�q*釧��1(\�Zq�3<ȯ��K�#�*P�W�A'#^��U4�<�@��?|��O��_�@"Sp7�t��ǀ_��Z
���m��}���з��'>)�UN�.�>&���`��)���������ܿ��S���z�GZ�o���n�W!@��(���;r��'G���.G �r���KB1�Y�>xGl�y��aIu���I��O�1��	:���7�܉md���+��1�n^F
��T�� ���Ǵ�ʽ�@�� ̝+��xڹ!���Ұ_����Ec�� �7q�-��c�i�C%#:;�x���5n����7�l*�n`P���������Q�P����#O����sO����]�x	p"Q�Ϊ煮^�To��0��\ER�S��=}�� ��7��=���;&e#���E�[�o��"� M-I2G��q.��A��;ʹzOq�(���M{_W+�� M�%��:fYoU�(/�V���#��H���`x#����������I\�i�P��g�!��K2� ��ۀ�\}��8
�;HT_�Xv�d�XL�d���/�}�i_]�����d�ˉΖ��*��pID�nO�19�l��t���N\�,��R��q�#���f��Rf�[�]1�Q�Q�����"��?�z8��ˁ��F;+]����hz��YOU��Ww���\� }S3!��g�hr��b�Cuǧ�躺R� >��&�x������,a�L���W��7���K�I�7���y��'*��]�EJ&�m#��yd*QU!2&�y�X�9Ԥ"�pB%
���f����(:
mS��y+~����0o2�0������Ȝv9�L0Ύj�-�uX�-;�ҍ���Q����C�E5)�A�f�#��h�������9E<C�T���RzX�?wk�F�p^�WD�(�/Fm�$�e���⇱��ܹ��]Pc��W�5�$7�!t�%1��؋ꎸ����7K��u@�r��n�����ܦ�BuՖ��r8����>(�vT�_gܥ�{��*uUu('��hU��kw�x*d�s�A{�˨�X5�ܐ��?�J]s=}���S�������Z�W;Z��X���v��{#����